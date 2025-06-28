# pip install numpy sounddevice aubio


import socket
import threading
import numpy as np
import sounddevice as sd
import aubio
import math

HOST = '127.0.0.1'
PORT = 12345

lock = threading.Lock()
current_note = -1.0

# Fonction de conversion fréquence → note
def convert_frequency_to_note(freq):
    if freq <= 0.0 or freq >= 1000:
        return -1
    n = 12.0 * math.log(freq / 440.0, 2)
    semitone = (n + 9.0) % 12.0

    NATURAL_NOTES = [
        0.0,  # Do
        0.5,  # Do#
        1.0,  # Re
        1.5,  # Re#
        2.0,  # Mi
        3.0,  # Fa
        3.5,  # Fa#
        4.0,  # Sol
        4.5,  # Sol#
        5.0,  # La
        5.5,  # La#
        6.0   # Si
    ]

    i = int(math.floor(semitone)) % 12
    f = semitone - i
    i_next = (i + 1) % 12
    val = (1.0 - f) * NATURAL_NOTES[i] + f * NATURAL_NOTES[i_next]
    return val % 7.0

# Thread de capture audio + détection pitch
def audio_thread():
    global current_note
    samplerate = 44100
    win_s = 1024  # taille fenêtre aubio
    hop_s = 512

    pitch_o = aubio.pitch("yinfft", win_s, hop_s, samplerate)
    pitch_o.set_unit("Hz")
    pitch_o.set_silence(-40)

    def callback(indata, frames, time, status):
        global current_note
        samples = indata[:, 0]
        pitch = pitch_o(samples)[0]
        note = convert_frequency_to_note(pitch)
        with lock:
            print(pitch, current_note)
            current_note = note

    with sd.InputStream(channels=1, callback=callback,
                        samplerate=samplerate, blocksize=hop_s):
        while True:
            sd.sleep(1000)

# Lancement du thread audio
threading.Thread(target=audio_thread, daemon=True).start()

# Serveur TCP principal
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    print("Serveur en écoute…")
    while True:
        conn, addr = s.accept()
        print(f"Connecté par {addr}")
        with conn:
            while True:
                data = conn.recv(1024)
                if not data:
                    continue
                print("Reçu :", data.decode().strip())
                with lock:
                    message = str(current_note) + "\n"
                conn.sendall(message.encode())
