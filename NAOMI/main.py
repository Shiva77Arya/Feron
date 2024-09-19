from types import coroutine
import pywhatkit
import Automations
import os
import pyttsx3
import pyautogui
#import psutil
from tkinter import Label
from tkinter import Entry
from tkinter import Button
import requests
from tkinter import Tk
from gtts import gTTS
from tkinter import StringVar
import PyPDF2
from pytube import YouTube
import datetime
from playsound import playsound
import keyboard
import pyjokes
import speech_recognition as sr
import features
from features import GoogleSearch
from features import website
from features import wikiped
from win10toast import ToastNotifier

engine = pyttsx3.init('sapi5')
voices = engine.getProperty('voices')
engine.setProperty('voices',voices[0].id)

def Speak(audio):
    """Converts text to speech in a more natural way."""
    # Print to console for debugging
    print("\n" + f": {audio}" + "\n")

    # Adjust the speech engine properties for a more natural sound
    engine.setProperty('rate', 200)  # Speed of speech
    engine.setProperty('volume', 5)  # Volume level (0.0 to 1.0)

    # Optional: Set a more human-like voice if available
    voices = engine.getProperty('voices')
    engine.setProperty('voice', voices[0].id)  # Change index for different voices

    # Speak the text
    engine.say(audio)
    engine.runAndWait()

def TakeCommand():
    """Listens for a command from the user and returns it as a string."""
    r = sr.Recognizer()

    with sr.Microphone() as source:
        # Inform the user that listening has started

        print(": Listening...")

        r.pause_threshold = 1
        r.adjust_for_ambient_noise(source)  # Adjusts for ambient noise
        audio = r.listen(source)

    try:
        # Recognize the command and convert it to lower case
        print(": Recognizing...")
        query = r.recognize_google(audio, language='en-in')
        #Speak(f"You said: {query}")
        print(f": Your Command: {query}\n")
    except sr.UnknownValueError:
        # Handle case where speech is not understood
        Speak("Sorry, I didn't catch that. Could you please repeat?")
        print(": Sorry, I didn't catch that.")
        return TakeCommand()  # Retry listening
    except sr.RequestError as e:
        # Handle case where Google API request fails
        Speak("Sorry, there seems to be an issue with the speech service.")
        print(f": Could not request results; {e}")
        return ""  # Or handle the error appropriately

    return query.lower()


def TaskExe():
    Speak("hello, I am Firaonn.")
    Speak("I am an A I virtual assistant created by Mr. Aarya")
    Speak("how can I help you")

    while True:

        query = TakeCommand()

        if 'google search' in query:    #corect                                     #error
            GoogleSearch(query)
        elif 'introduce yourself' in query:
            Speak("Hello, My name is Firaonn  . I am a Virtual Assitant created by Mr. Aryaa using python."
                  " here to make your digital life easier and more enjoyable. I’m built with Python, which means I’ve got some pretty cool features up my sleeve. I can automate your web browsing, help you find exactly what you’re looking for on YouTube,wikipedia or anywhere on the internet and play your favorite music and videos . If you need answers or information, I’ll tap into ChatGPT to get you the best results. "
                  "I can even visit websites and tell you what I find—all through simple voice commands and many more such features."
                  " Just let me know what you need, and I’ll take care of the rest!")
        elif 'welcome speech' in query:
            Speak("Hello and welcome to NCS!")
            Speak("I’m Firaonn, your dedicated virtual assistant. I’m here to enhance your experience by assisting with tasks, managing schedules, and providing information with just a few commands.")
            Speak("Respected Guests I hope you find everything you need for an informative and enjoyable visit")
            Speak("Let’s make something extraordinary happen together.")
            Speak("Thank you for being here")
        elif 'youtube search' in query:  #correct
            Query = query.replace("NAOMI","")
            query = Query.replace("youtube search","")
            from features import YouTubeSearch
            YouTubeSearch(query)
        elif 'launch website' in query: #correct
            website(query)
        elif 'wikipedia' in query:  #correct
            wikiped(query)


        elif 'set alarm' in query:
            from features import Alarm
            Alarm(query)

        elif 'download' in query:                                               #error
            from features import DownloadYouTube
            DownloadYouTube()
            
        elif 'speed test' in query:
            from features import SpeedTest
            SpeedTest()

        elif 'whatsapp message' in query:

            name = query.replace("whatsapp message","")
            name = name.replace("send ","")
            name = name.replace("to ","")
            Name = str(name)
            Speak(f"For whom is the message for {Name}")
            MSG = TakeCommand()
            from Automations import WhatsappMsg
            WhatsappMsg(Name,MSG)

        elif 'call' in query:
            from Automations import WhatsappCall
            name = query.replace("call ","")
            name = name.replace("NAOMI ","")
            Name = str(name)
            WhatsappCall(Name)

        elif 'show chat' in query:
            Speak("With Whom ?")
            name = TakeCommand()
            from Automations import WhatsappChat
            WhatsappChat(name)

        elif 'my location' in query:

            from features import My_Location

            My_Location()

        elif 'where is' in query:

            from Automations import GoogleMaps
            Place = query.replace("where is ","")
            Place = Place.replace("NAOMI" , "")
            GoogleMaps(Place)

        elif 'online' in query:

            from Automations import OnlinClass

            Speak("Tell Me The Name Of The Class .")

            Class = TakeCommand()

            OnlinClass(Class)

        elif 'write a note' in query:

            from Automations import Notepad

            Notepad()

        elif 'dismiss' in query:

            from Automations import CloseNotepad

            CloseNotepad()

        elif 'corona cases' in query:

            from features import CoronaVirus

            Speak("Which Country's Information ?")

            cccc = TakeCommand()

            CoronaVirus(cccc)
        elif 'you may go' in query:
            Speak("ok sir, you can call me anytime!")
            Speak("just say wake up NAOMI")
            break

        else:

            from Database.Chatbot.ChatBot import ChatterBot

            reply = ChatterBot(query)

            Speak(reply)

            if 'bye' in query:

                break

            elif 'exit' in query:

                break

            elif 'go' in query:

                break

TaskExe()