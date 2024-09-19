import pywhatkit
import wikipedia
from pywikihow import RandomHowTo, search_wikihow
import os
import speech_recognition as sr
import webbrowser as web
import bs4
import pyttsx3
from time import sleep
import requests
import webbrowser as web
import requests
from geopy.geocoders import Nominatim

engine = pyttsx3.init('sapi5')
voices = engine.getProperty('voices')
engine.setProperty('voices',voices[0].id)

def Speak(audio):
    print(" ")
    print(f": {audio}")
    engine.say(audio)
    engine.runAndWait()
    print(" ")

def TakeCommand():

    r = sr.Recognizer()

    with sr.Microphone() as source:

        print(": Listening....")

        r.pause_threshold = 1

        audio = r.listen(source)


    try:

        print(": Recognizing...")

        query = r.recognize_google(audio,language='en-in')

        print(f": Your Command : {query}\n")

    except:
        return ""

    return query.lower()

def GoogleSearch(term):
    query = term.replace("NAOMI","")
    query = term.replace("google search","")
    query = query.replace("what is","")
    query = query.replace("how to","")
    query = query.replace("what is","")
    query = query.replace(" ","")
    query = query.replace("what do you mean by","")

    """writeab = str(query)

    oooooo = open('D:\\Desktop\\NAOMI\\Data.txt','a') #articulate form to write into this file
    oooooo.write(writeab)
    oooooo.close()

    Query = str(term)"""

    pywhatkit.search(query)
    Speak("done sir")

    # os.startfile('C:\\Users\\shiva\\OneDrive\\Desktop\\NAOMI\\Database\\ExtraPro\\start.py')

    """if 'how to' in query:

        max_result = 1

        how_to_func = search_wikihow(query=query,max_results=max_result)

        assert len(how_to_func) == 1

        how_to_func[0].print()

        Speak(how_to_func[0].summary)

    else:

        search = wikipedia.summary(query,2)

        Speak(f": According To Your Search : {search}")"""

def YouTubeSearch(term):
    result = "https://www.youtube.com/results?search_query=" + term
    web.open(result)
    Speak("This Is What I Found For Your Search .")
    pywhatkit.playonyt(term)
    Speak("This May Also Help You Sir .")
def website(query):
    Speak("tell me the name of the website")
    name=TakeCommand()
    web1='https://www.'+name+'.com'
    web.open(web1)
def wikiped(query):
    Speak("searching on wikipedia.....")
    query=query.replace('wikipedia',"")
    web.open("https://en.wikipedia.org/wiki/" + query)
    wiki=wikipedia.summary(query,2)
    Speak(f"According to wikipedia" + wiki)
    



def Alarm(query):

    TimeHere=  open('D:\\Desktop\\NAOMI\\Data.txt','a')
    TimeHere.write(query)
    TimeHere.close()
    os.startfile("D:\\Desktop\\NAOMI\\Database\\ExtraPro\\Alarm.py")

def DownloadYouTube():
    from pytube import YouTube
    from pyautogui import click
    from pyautogui import hotkey
    import pyperclip
    from time import sleep

    sleep(2)
    click(x=942,y=59)
    hotkey('ctrl','c')
    value = pyperclip.paste()
    Link = str(value) # Important 

    def Download(link):


        url = YouTube(link)


        video = url.streams.first()


        video.download('D:\\Desktop\\NAOMI\\Database\\youtube')


    Download(Link)


    Speak("Sir , I Have Downloaded The Video .")

    Speak("You Can Check It Out.")


    os.startfile('D:\\Desktop\\NAOMI\\Database\\youtube\\')

def SpeedTest():
    #web.open("https://fast.com/")
    Speak("your network speed is being displayed on the screen")
    os.startfile("D:\\Desktop\\NAOMI\\Database\\Gui Programs\\SpeedTestGui.py")

def DateConverter(Query):

    Date = Query.replace(" and ","-")
    Date = Date.replace(" and ","-")
    Date = Date.replace("and","-")
    Date = Date.replace("and","-")
    Date = Date.replace(" ","")

    return str(Date)

def My_Location():

    op = "https://www.google.co.in/maps/place/Khyora,+Kanpur,+Uttar+Pradesh/@26.5041629,80.2510385,13z/data=!3m1!4b1!4m5!3m4!1s0x399c382ed4de9ebb:0x99dc2a9f39259c27!8m2!3d26.5067532!4d80.2841051"

    Speak("Checking....")

    web.open(op)

    ip_add = requests.get('https://api.ipify.org').text

    url = 'https://get.geojs.io/v1/ip/geo/' + ip_add + '.json'

    geo_q = requests.get(url)

    geo_d = geo_q.json()

    state = geo_d['city']

    country = geo_d['country']

    Speak(f"Sir , You Are Now In {state , country} .")


def My_Location():
    # Get the public IP address
    ip_add = requests.get('https://api.ipify.org').text

    # Get geo-location data based on IP address
    url = f'https://get.geojs.io/v1/ip/geo/{ip_add}.json'
    geo_q = requests.get(url)
    geo_d = geo_q.json()

    # Extract coordinates and location details
    latitude = geo_d['latitude']
    longitude = geo_d['longitude']
    city = geo_d['city']
    country = geo_d['country']

    # Construct Google Maps URL with dynamic coordinates
    maps_url = f"https://www.google.com/maps/@{latitude},{longitude},13z"

    Speak("Checking your location...")

    # Open the Google Maps URL in the default web browser
    web.open(maps_url)

    # Provide location details
    Speak(f"Sir, you are currently in {city}, {country}.")

def CoronaVirus(Country):

    countries = str(Country).replace(" ","")

    url = f"https://www.worldometers.info/coronavirus/country/{countries}/"

    result = requests.get(url)

    soups = bs4.BeautifulSoup(result.text,'lxml')

    corona = soups.find_all('div',class_ = 'maincounter-number')

    Data = []

    for case in corona:

        span = case.find('span')

        Data.append(span.string)

    cases , Death , recovored = Data

    Speak(f"Cases : {cases}")
    Speak(f"Deaths : {Death}")
    Speak(f"Recovered : {recovored}")