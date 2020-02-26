---
layout: default
banner: main
title:  "Every genserver an independant service"
---

# Intro

For a while I was struggling with how to test the OTP layer (TODO: more desc). I had that struggle becasue I didn't see genserver for what it truely was. 
GenServer is a micro-service. Think about non-micro services for a bit. Web applications (or non-micro services) are architectured in MVC to decouple the views from the buisness logic. Web applications are independantly deployable. Our GenServers should act the same way. All incoming data should come from the view (or public api) the controller is callback functions and we should have a struct that acts as the model (thats where the buisness model lives).
