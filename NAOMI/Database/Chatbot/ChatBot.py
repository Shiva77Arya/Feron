import random

Hello = ('hello','hey','hii','hi')

Sorry=("Sorry", "Apologies", "I am sorry", "My apologies")
SorryAnswer=("It's Okay", "No problem")
thanks=("thank you", "thanks")
thank_you_reply=("You're Welcome","My pleasure", "No Problem","Happy to help you","You're Welcome! Have a great day", "My pleasure!, Have a nice day")

reply_Hello = ('Hello there , I am Firaonn .',
            "Hey , What's Up ?",
            "Hey How Are You ?",
            "Hello Sir , Nice To Meet You Again .")

Bye = ('bye','exit','sleep','go')

reply_bye = ('Have a great day',
            "It's Okay",
            "It was nice meeting you",
            "It was nice talking to you",
            "It Will Be Nice To Meet You again, see you.",
            "Bye sir.",
            "Thank you sir.",
            "Okay sir.")

How_Are_You = ('how are you')

reply_how = ('I Am Fine.Thanks For Asking.',
            "I'm Fine.Thanks For Asking.",
            " I am doing good.Thanks For Asking.")

nice = ('nice','good','thanks')

reply_nice = ('Thanks .',
            "Ohh , It's Okay .",
            "Thanks To You.")

Functions = ['functions','abilities','what can you do','features']

reply_Functions = (' well,I Can Perform Varieties Of Tasks dear ,it basically depends upon what you want me to do, ?',
            'I am a good listener,you can talk to me anytime you want.',
            'I can automate a lot of things for you to make your life a bit easier or I can be a good friend of yours if you want one'
            'If You Want Me To Tell all of My Features , Call : Print Features !')

sorry_reply = ("Sorry , That's Beyond My Abilities .",
                "Sorry ,I am afraid I Can't Do That .",
                "Sorry , I still have a lot to learn")

def ChatterBot(Text):

    Text = str(Text)

    for word in Text.split():

        if word in Hello:

            reply = random.choice(reply_Hello)

            return reply

        elif word in Bye:

            reply = random.choice(reply_bye)

            return reply

        elif word in Sorry:

            reply=random.choice(SorryAnswer)

            return reply

        elif word in thanks:

            reply = random.choice(thank_you_reply)

            return reply

        elif word in How_Are_You:

            reply_ = random.choice(reply_how)

            return reply_

        elif word in Functions:

            reply___ = random.choice(reply_Functions)

            return reply___

        else:

            return random.choice(sorry_reply)

