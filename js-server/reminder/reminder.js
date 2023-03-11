const sqlDb = require('./database/mysql');
const {pushNotification} = require('./Notification/notify');
const CronJob = require('cron').CronJob;

// const doneSet = new Set();
let lastFetchedTime = 0;

const FetchAndPushFn = () => {

    let currTime = new Date();
    currTime = currTime.toISOString().split('T')[1];

    sqlDb.query("SELECT goal_title, FCM_Token FROM goalNotif WHERE notif <= ? AND notif > ?", [
        currTime,
        lastFetchedTime
    ], 
    (err, result) => {
        if (err) throw err;

        // console.log(result);
        
        result.forEach(goal => {
            let titleStatus = `Its tine for ${goal}`;
            let bodyStatus = "";
            console.log(String(goal.FCM_Token));
            pushNotification(titleStatus, bodyStatus, String(goal.FCM_Token));
        })

        //! push each HERE

    });

}

const resetFn = () => {
    // doneSet.clear();
    lastFetchedTime = 0;
}

let job = new CronJob(
	'15 * * * * *',
	FetchAndPushFn,
	null,
	true,
	'America/Los_Angeles'
);

let anotherJob = new CronJob(
    '40 * * * * *',
	resetFn,
	null,
	true,
	'America/Los_Angeles'
)