import speech_recognition as sr
import subprocess

def run_naomi_main():
    print("Hotword detected! Running NAOMI's main.py...")
    subprocess.Popen(['python', 'D:/Desktop/NAOMI/main.py'])  # Update path as needed

def listen_for_hotword():
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        print("Listening for hotwords...")
        while True:
            audio = recognizer.listen(source)
            try:
                text = recognizer.recognize_google(audio)
                text.lower()
                print(f"You said: {text}")
                if any(hotword in text for hotword in ["hey firaun",'hay firaun', "hi firaun", "okay firaun", "wake up firaun", "good morning firaun", "good afternoon firaun", "good evening firaun,"
                    "hey firon","hay firon", "hi firon ", "okay firon", "wake up firon", "good morning firon", "good afternoon firon", "good evening firon,"]):
                    run_naomi_main()
            except sr.UnknownValueError:
                print(f"You said: {text}")
                pass
            except sr.RequestError as e:
                print(f"Could not request results; {e}")

if __name__ == "__main__":
    listen_for_hotword()
