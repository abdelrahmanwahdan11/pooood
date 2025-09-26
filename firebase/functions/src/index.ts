/**
 * BidGlass Firebase Cloud Functions template.
 *
 * The concrete Firebase implementation is intentionally commented out so the
 * Flutter application can run in a preview-only mode before the backend is
 * connected. Uncomment and adjust the code once Firebase services are ready.
 */

/*
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

export const onBidCreated = functions.firestore
  .document('auctions/{auctionId}/bids/{bidId}')
  .onCreate(async (snap, context) => {
    const bid = snap.data();
    const auctionRef = db.doc(`auctions/${context.params.auctionId}`);
    await db.runTransaction(async (tx) => {
      const auctionSnap = await tx.get(auctionRef);
      if (!auctionSnap.exists) {
        throw new functions.https.HttpsError('not-found', 'Auction missing');
      }
      const auctionData = auctionSnap.data()!;
      const minIncrement = auctionData.minIncrement || 0;
      const currentBid = auctionData.currentBid || 0;
      if (bid.amount < currentBid + minIncrement) {
        throw new functions.https.HttpsError('failed-precondition', 'Bid too low');
      }
      let endsAt = auctionData.endsAt?.toDate?.() ?? new Date();
      const now = new Date();
      if (endsAt.getTime() - now.getTime() < 60 * 1000) {
        endsAt = new Date(now.getTime() + 60 * 1000);
      }
      tx.update(auctionRef, {
        currentBid: bid.amount,
        biddersCount: admin.firestore.FieldValue.increment(1),
        endsAt,
      });
    });

    // TODO: send targeted notifications to watchers (topic auction_{id}).
    await messaging.sendToTopic(`auction_${context.params.auctionId}`, {
      notification: {
        title: 'New bid received',
        body: `Bid placed at ${bid.amount}`,
      },
    });
  });

export const onProductCreated = functions.firestore
  .document('products/{productId}')
  .onCreate(async (snap) => {
    const data = snap.data();
    if (!data.location) return;
    // TODO: Compute geohash server-side (use geofire-common) and update document.
    return snap.ref.update({ geohashStatus: 'pending' });
  });

export const onDealPublished = functions.firestore
  .document('deals/{dealId}')
  .onCreate(async (snap) => {
    const data = snap.data();
    const city = data.city || 'global';
    await messaging.sendToTopic(`deals_city_${city.toLowerCase()}`, {
      notification: {
        title: 'New deal!',
        body: data.productId || 'Check the latest discount',
      },
    });
  });

export const onWantedMatched = functions.firestore
  .document('products/{productId}')
  .onUpdate(async (change) => {
    // TODO: Implement matching logic comparing product price drops against wanted targetPrice.
    functions.logger.info('Evaluate wanted matches for', change.after.id);
  });

export const scheduledCleanup = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();
    const snapshot = await db
      .collection('auctions')
      .where('endsAt', '<', now)
      .where('status', '==', 'active')
      .get();
    const batch = db.batch();
    snapshot.docs.forEach((doc) => batch.update(doc.ref, { status: 'ended' }));
    await batch.commit();
  });
*/

export {};
