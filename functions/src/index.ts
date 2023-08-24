import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Timestamp } from "firebase-admin/firestore";
admin.initializeApp();
// create new post
export const createNewPost = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'You must be authenticated to use this function.');
  } else {
    const collectionRef = admin.firestore().collection("user");
    const currentUser = await collectionRef.doc(context.auth.uid).get();
    if (currentUser) { 
      const newPost = {
        'img': data.img,
        'content': data.content,
        'likes': [],
        'time': Timestamp.now()
      }
      const docRef = collectionRef.doc(context.auth.uid).collection("posts").doc();

      try {
        await admin.firestore().runTransaction(async (transaction) => {
          transaction.set(docRef, newPost);
        });
        return "create successed!"
      } catch (error) {
        throw error;
      }
    } else {
      throw new functions.https.HttpsError('not-found', 'can not found user in database.');
    }
  }
})

// like post
export const likePost = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'You must be authenticated to use this function.');
  } else {
    const collectionRef = admin.firestore().collection("user");
    const currentUser = await collectionRef.doc(context.auth.uid).get();
    const a: string[] = currentUser.get("friends");
    if (currentUser.id == data.userId ||
      currentUser.get("role") == "admin" || a.includes(data.userId)) {
      const documentReference =
        collectionRef.doc(data.userId).collection('posts').doc(data.postId);

      try {
        await admin.firestore().runTransaction(async (transaction) => {
          const documentSnapshot = (await transaction.get(documentReference));
          const docData = documentSnapshot.data();
          let likes : string[] = docData != undefined ? docData["likes"] : [];
          if (likes.includes(data.userId)) {
            likes = likes.filter((friendId) => friendId != data.userId)
          } else {
            likes.push(data.userId)
          }

          transaction.update(documentReference, { 'likes': likes });
        });
        return "liked!!"
      } catch (error) {
        throw error;
      }
    } else {
      console.log(currentUser.get("friends"))
      throw new functions.https.HttpsError('permission-denied', 'Your request is not permisstion.');
    }
  }


})

// delete post
export const deletePost = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'You must be authenticated to use this function.');
  } else {
    const collectionRef = admin.firestore().collection("user");
    const currentUser = await collectionRef.doc(context.auth.uid).get();
    if (currentUser) {
      if (currentUser.get("role") == "admin" || currentUser.id == data.ownerId) {
       
          const documentReference = admin.firestore()
            .collection('user')
            .doc(data.ownerId)
            .collection('posts')
            .doc(data.postId);

          try{
            admin.firestore().runTransaction(async (transaction) => {
              const documentSnapshot =
                await transaction.get(documentReference);
              if (documentSnapshot.exists) {
                transaction.delete(documentReference);
              }
            });
          }catch(error){
            return error;
          }
        }else{
          throw new functions.https.HttpsError('permission-denied', 'Your request is not permisstion.');
        }
      }
     else {
      throw new functions.https.HttpsError('not-found', 'can not found user in database.');
    }
  }
})


// send message
export const sendMessage = functions.https.onCall(async (data,context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'You must be authenticated to use this function.');
  }else{
    const room = await admin.firestore().collection('chat_room').doc(data.roomId).get();
    const members: string[] = room.get('members');
    if(!(members.includes(context.auth.uid) && context.auth.uid == data.sender)){
      throw new functions.https.HttpsError('permission-denied', 'Your request is not permisstion.');
    }else{
      const newMessage = {
        'content': data.content,
        'sender': data.sender,
        'time': new Timestamp(data.seconds,data.nanoseconds)
      }

      admin.firestore().runTransaction(async (transaction) => {
        const messRef = admin.firestore().collection('chat_room').doc(data.roomId).collection("messages").doc();
        transaction.set(messRef,newMessage);
        return 'ok';
      })
    }
  }

})