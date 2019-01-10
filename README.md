# vexillolobot
A Twitter bot that procedurally generates flag designs and uplaods them to twitter periodically

The Flags are generated using a Processing file called Flag_Bot.pde. The flag bot is executed through a node.js file called bot.js. 
bot.js uses the twit node module and fs in order to generate the image and upload it to twitter.
This bot is hosted on an amazon ec2 ubuntu instance and tweets every 8 hours
follow it at https://twitter.com/vexillolobot
