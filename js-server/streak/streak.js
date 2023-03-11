// import { getData } from "./notifyModule";
const firebaseDb = require("./database/firebase");
const {pushNotification} = require("./Notification/notify");

const CronJob = require('cron').CronJob;

const streakThreshold = [3,6,9,12,15];

const streakFn = async () => {

    const allUsers = await firebaseDb.collection('users').get();
    // console.log(allUsers);

    allUsers.forEach(async (user) => {
        console.log("here", user.fcmToken);
        
        const method = await firebaseDb.collection('users').doc('Ad6jgeLy8DYG28RxUcCjyvS36gk1').collection("habits").get();

        console.log("here too");
        
        method.forEach(async habit => {
            console.log("here threee");
            
            // const habitt = await firebaseDb.collection('users').doc('Ad6jgeLy8DYG28RxUcCjyvS36gk1').collection("habits").doc(habit).get();

            // console.log(habitt);
            const intervals = habit.get('intervals');
            console.log(intervals);

            const size = intervals.length;

            const currDateFull = new Date(Date.now());
            console.log(currDateFull);
            const currDate = currDateFull.toISOString().split("T")[0];

            let streak = 0;

            console.log(intervals[size - 1].end_date);
            console.log(intervals[size - 1].end_date.toDate())

            if (intervals[size - 1].end_date.toDate().toISOString().split("T")[0] === currDate) {
                streak = (intervals[size - 1].end_date.toDate() - intervals[size - 1].start_date.toDate())/(1000 * 60 * 60 * 24) + 1;
                // if (streak in streakThreshold) {
                    let titleStatus = `Congratulations ${streak} ${habit.get('title')}`;
                    let bodyStatus = "";
                    console.log(streak);
                    pushNotification(titleStatus, bodyStatus, user.get('fcmToken'));
                // }
            } else {
                streak = (currDateFull - intervals[size - 1].end_date.toDate())/(1000 * 60 * 60 * 24);
                // if (streak in streakThreshold) {
                    let titleStatus = `Hi there looks like you have missed for ${streak} ${habit.title}`;
                    let bodyStatus = "";
                    console.log(streak);
                    pushNotification(titleStatus, bodyStatus, user.get('fcmToken'));
                // }
            }
        });
    })
    
    
}

let anotherJob = new CronJob(
    '5 * * * * *',
	streakFn,
	null,
	true,
	'America/Los_Angeles'
)


