import os
import GoogleImageScrapper
from GoogleImageScrapper import GoogleImageScrapper
def GoogleImage():
    oo=open('D:\\Desktop\NAOMI\\Data.txt','rt')
    query=str(oo.read())
    oo.close()
    print(query)
    pppp=open('D:\\Desktop\\NAOMI\\Data.txt','r+')
    pppp.truncate(0)
    pppp.close()

    webdriver="D:\\Desktop\\NAOMI\\Database\\webdriver\\chromedriver.exe"
    photos="D:\\Desktop\\NAOMI\\Database\\GooglePhotos"

    search_keys = query #changes made
    number=10
    head=False
    max=(1000,1000) #resolution
    min=(0,0)

    for search_key in search_keys:
        image_search=GoogleImageScrapper(webdriver,photos,search_keys,number,head,min,max)
        image_url=image_search.find_image_urls()
        image_search.save_images(image_url)
    
    os.startfile(photos)

GoogleImage()