

console.log('the bot is starting');

var Twit = require('twit'); //this is like an import statement
var config = require('./config'); //api key is stored here
var fs = require('fs'); //import for file management
var exec = require('child_process').exec;



var T = new Twit(config) //creating a new twit object with my api keys



function tweetIt() {
  var cmd = 'Flag_Bot.linux64/Flag_Bot' //the stuff that I run in the commandline
  exec(cmd,processing); //invoking the exec variable that will run cmd in the commandline and then call processing().
  function processing() {
    var filename = 'Flag_Bot.linux64/output.png'
    var params = {encoding: 'base64'}
    var b64content = fs.readFileSync(filename,params);
    T.post('media/upload',{media_data:b64content},uploaded);
    function uploaded(err,data,response) {
      var id = data.media_id_string;
      var tweetStuff = {
        status: ' ',
        media_ids: [id],
      };
      T.post('statuses/update', tweetStuff, posted)
    }
  }
}

tweetIt();
setInterval(tweetIt,1000*60*60*8);


function posted(err, data, response) {
  fs.writeFile("output.json",JSON.stringify(data,null,'\t'), writeToOutput)
};

function writeToOutput(err) {
  if (err) {
    return console.log(err);
  }
  console.log("output file written succesfuly");
};
