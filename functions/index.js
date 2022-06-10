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

exports.deleteAllTaskWhenProjectDeleted = functions.firestore.document('projects/{postId}').onDelete(
  async (snap, context) => {
      db.collection('tasks').where('projectId','==',snap.id).get().then(
        snapshot => {
          for(let i = 0; i <snapshot.docs.length; i++){
            snapshot.docs[i].delete();
          }
        }
      );
  }
)

exports.deletePostComment = functions.firestore.document('post/{postId}').onDelete(
  async (snap, context) => {
      db.collection('comments').where('postId','==',snap.id).get().then(
        snapshot => {
          for(let i = 0; i <snapshot.docs.length; i++){
            snapshot.docs[i].ref.delete();
          }
        }
      );
  }
)

exports.deleteMessageWhenConversationDeleted = functions.firestore.document('conversations/{conversationId}').onDelete(
  async (snapshot, ctx) => {
    db.collection('messages').doc(snapshot.id).collection('messages').where('conversationId', '==', snapshot.id).get().then(
      snap => {
        const snapDocs = snap.docs;
        for(let i = 0; i <snapshot.docs.length; i++){
          snapshot.docs[i].ref.delete();
        }
      }
    )
  }
);

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
                  title: `${author.name}`,
                  body: message.content,
                  notification_count: '1',
                },
                data: {
                  type : "message",
                  targetId : message.conversationId
                }
              }
            console.log(payload);
            fcm.sendToDevice(user.token,payload);
        }
      }
   }
});

exports.sendNotification = functions.firestore.document('notifications/{userId}/notifications/{notificationId}').onCreate(
  async (snapshot, context) => {
    const notification = snapshot.data();
    const notifierToken = (await db.collection('users').doc(notification.notifierId).get()).data().token;
    if(!!notifierToken){
        const notificationMessage = await getNotificationMessage(notification);
        const payload = {
            notification : {
              title: `JoinMe`,
              body: notificationMessage,
              notification_count: '1',
            },
            data: {
              "type" : notification.notificationType,
              "notifierId": notification.notifierId,
              "notificationId": notification.id,
              "targetId": notification.targetId
            }
          }
        fcm.sendToDevice(notifierToken,payload);
    }
  }
)

async function getNotificationMessage (notification) {
  const notifyType = notification.notificationType;
  const actorName = (await db.collection('users').doc(notification.actorId).get()).data().name;
  switch (notifyType) {
    case 'like':
      return `${actorName} like your post.`
    case 'likeComment':
      var postId = notification.targetId.split('/')[0];
      var commentId = notification.targetId.split('/')[1];
      var commentContent = (await db.collection('comments').doc(postId).collection('comments').doc(commentId).get()).data().content;
      return `${actorName} like your comment "\n${commentContent}"`;
    case 'comment':
      postId = notification.targetId.split('/')[0];
      commentId = notification.targetId.split('/')[1];
      commentContent = (await db.collection('comments').doc(postId).collection('comments').doc(commentId).get()).data().content;
      return `${actorName} comment your post\n"${commentContent}"`;
    case 'invite':
      const projectName = (await db.collection('projects').doc(notification.targetId).get()).data().name;
      return `${actorName} invite you to project "${projectName}"`;
    case 'assign':
      const taskName = (await db.collection('tasks').doc(notification.targetId).get()).data().name;
      return `${actorName} assign you a task "${taskName}"`;
    default:
      break;
  }
}