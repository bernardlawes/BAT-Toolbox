@echo off
REM Launch Microsoft Edge with multiple tabs in Existing Window
start msedge "https://calendar.google.com"
start msedge "https://outlook.office.com/mail/"
start msedge "https://chat.openai.com"


REM Launch Microsoft Edge with multiple tabs in New Windows
REM ChatGPT and Claude
start msedge --new-window "https://chatgpt.com/" "https://claude.ai/new" 
REM "https://gemini.google.com/app?hl=en-GB" "https://grok.com/?referrer=website"

REM Repository
start msedge --new-window "https://github.com/bernardlawes/" 
REM"https://gist.github.com/bernardlawes" "https://github.com/settings/personal-access-tokens?page=1" "https://app.roboflow.com/login"

REM Communication & Collaboration
start msedge --new-window "https://linkedin.com/in/lawes" 
REM "https://www.toptal.com/"

REM Computer Vision & AI Study / Dev
start msedge --new-window "https://www.computervision.zone/" "https://colab.research.google.com/notebooks/"
