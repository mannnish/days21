const sqlDb = require('./database/mysql');
const fireDb = require('./database/firebase');

const getStartTime = async (preset, uid) => {
  console.log(preset);

    const user = await fireDb.collection('users').get();

    // console.log(user.length);
    
    user.forEach(id => {
      // console.log(id.data());
      if(id.get('uid') == uid) {
        const idx = id.data().daySchedule.findIndex(ele => {
          return ele.preset_value === preset
        })
        console.log(idx);
  
        if(idx==-1) {
          return -1;
        }

        // console.log(String(id.data().daySchedule[idx].start_time).split(' ')[1])
  
        return String(id.data().daySchedule[idx].start_time).split(' ')[1];
      }
    })

    
}

const observer = fireDb.collection('habits')
  .onSnapshot(querySnapshot => {
    querySnapshot.docChanges().forEach(async (change) => {
      if (change.type === 'added') {
          console.log("New city: ", change.doc.id);
          console.log(change.doc.data().presetValue, change.doc.data().uid);

          let startTime = await getStartTime(change.doc.data().presetValue, change.doc.data().uid);

          // console.log(startTime);
          console.log(startTime)

          if(startTime == -1 || startTime === undefined) {
            startTime = "00:00:00.000";
          }

          startTime = startTime.split('.')[0];


          console.log(startTime)

          sqlDb.query("INSERT INTO goalNotif VALUE (?, ?, ?, ?, ?)", [
              change.doc.id,
              change.doc.data().title,
              change.doc.data().presetValue,
              change.doc.data().fcmToken,
              startTime
          ], 
          (err) => {
            if (err) throw err;
          });
      }
      if (change.type === 'modified') {
        console.log('Modified city: ', change.doc.id);

        sqlDb.query("UPDATE goalNotif SET goal_title= ? , preset= ? WHERE id = ?", [
            change.doc.data().title,
            change.doc.data().presetValue,
            change.doc.id
        ], 
        (err) => {
          if (err) throw err;
        });
      }
      if (change.type === 'removed') {
        console.log('Removed city: ', change.doc.id);

        sqlDb.query("UPDATE FROM goalNotif WHERE id = ?", [
            change.doc.id
        ], 
        (err) => {
          if (err) throw err;
        });
      }
    });
  });
