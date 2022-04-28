// 
const axios = require('axios');
const fs = require('fs');
const parse = require('csv-parse')

country = 'US'
year = '2020'
month = '12'
day = '25'

let resps = [];
let promises = [];

const url = "https://holidays.abstractapi.com/v1/?api_key=a05d39b051ce4b2f995da5628acb3806&country=" + country + "&year=" + year + "&month=" + month + "&day=" + day + "";



const start = async() => {
    for (let i = 0; i < 30; i++) {
        await axios.get(url)
            .then((res) => {
                console.log(res)
            })
            .catch((err) => {
                console.log(err)
            })
    }
}

var csvData=[];
fs.createReadStream(req.file.path)
    .pipe(parse({delimiter: ':'}))
    .on('data', function(csvrow) {
        console.log(csvrow);
        //do something with csvrow
        csvData.push(csvrow);        
    })
    .on('end',function() {
      //do something with csvData
      console.log(csvData);
    });

// start()


