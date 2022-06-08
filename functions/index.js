const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
var db = admin.firestore();
var fcm = admin.messaging();

exports.deleteTask = functions.firestore.document('tasks/{docId}').onDelete(
    async (snap, context) => {
        const deletedTask = snap.data();
        const subTasks = deletedTask.subTasks;
        for(var index in subTasks){
          await db.collection('tasks').doc(subTasks[index]).delete();
        }
    }
)

exports.deletePostComment = functions.firestore.document('post/{postId}').onDelete(
  async (snap, context) => {
      db.collection('comments').where('postId','==',snap.id).get().then(
        snapshot => {
          for(let i = 0; i <snapshot.docs.length; i++){
            snapshot.docs[i].delete();
          }
        }
      );
  }
)

exports.newCommentNotification = functions.firestore.document('comments/{postId}/comments/{commentId}').onCreate(
  async (snapshot, context)=>{
    const commentData= snapshot.data();
    const post = (await db.collection('posts').doc(commentData.postId).get()).data();
    
  }
);

// exports.postLikeNotification = functions.firestore.document('posts/{postId}').onUpdate(
//     (change, context) => {
//         const likeData = change.after.get('likes');
//         console.log(likeData);
//         const previousLike = change.before.get('likes');
//         console.log(previousLike);
//         const postId = change.after.id;
//         const authorId = change.after.get('authorId');
//         console.log(postId);
//         //Check if have new user like post
//         for(let i = 0; i< likeData.length; i++){
//             var notInPrevious = true;
//             for(let j = 0; j < previousLike.length; j++){
//                 if(likeData[i] == previousLike[j]){
//                     notInPrevious = false;
//                     break;
//                 }   
//             }
//             if(notInPrevious){
//                 //Check notification list
//                 var newData = {};
//                 db.collection('notifications').doc(authorId).collection('notifications').where('targetId','==',postId).where('notificationType','==','like').limit(1).get().then( query =>{
//                     if(query.docs.length != 0){
//                         console.log('No bat dau vao day ne');
//                         const notification = query[0];
//                         newData.actorId = likeData[i];
//                         newData.lastChange = Date.;
//                         notification.update(newData);
//                     }
//                     else{
//                         console.log('Hmm no tao moi ne');
//                         newData.id = '';
//                         newData.actorId = likeData[i];
//                         newData.lastChange = Date.now();
//                         newData.targetId = postId;
//                         newData.notificationType = 'like';
//                         db.collection('notifications').doc(authorId).collection('notifications').add(newData).then(docRef => {
//                             docRef.update({'id': docRef.id});
//                         });
//                     }
//                 });
//             }
//         }        
//     }
// );

exports.notifyNewMessage = functions.firestore.document('messages/{conversationId}/messages/{messageId}')
.onCreate(
  async (snapshot, context) => {
    const message = snapshot.data();
    //Get conversation and members
    const conversation = (await db.collection('conversations').doc(message.conversationId).get()).data();
    const members =  conversation.members;
    
    //Get Author data
    const author = (await db.collection('users').doc(message.authorId).get()).data();
    for(var index in members){
      if(!(members[index] === message.authorId)){
        const user = (await db.collection('users').doc(members[index]).get()).data();
        console.log(user);
        if(!!user.token){
            const payload = {
                notification : {
                  title: `JoinMe | ${author.name}`,
                  body: message.content,
                  clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                }
              }
            fcm.sendToDevice(user.token,payload);
        }
      }
   }
});