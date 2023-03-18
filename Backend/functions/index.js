// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
// admin.initializeApp(); //original
admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

// const stripe = require('stripe')(functions.config().stripe.testkey)

const Stripe = require('stripe');
// const stripe = Stripe('sk_test_DarDPNwErYCGZym68iTRTTLD');
const stripe = Stripe('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');

//test publishable key : pk_test_wnRxX3ShFy6jDraeTNFjXfV4
//test secret key : sk_test_DarDPNwErYCGZym68iTRTTLD
//live publishable key : pk_live_6e9JKARc02RUpHCuxuD8iFow
//live secret key : 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

// exports.stripeCharge = functions.database
// 								.ref('/payments/{userId}/{paymentId}')
// 								.onWrite(event => {

// 	const payment = event.data.val();
// 	const userId = event.params.userId;
// 	const paymentId = event.params.paymentId;

// 	// checks if payment exists or if it has already been charged
// 	if (!payment || payment.charge) return;

// 	return admin.database()
// 				.ref('/users/${userId}')
// 				.once('value')
// 				.then(snapshot => {
// 					return snapshot.val();
// 				})
// 				.then(customer => {
// 					const amount = payment.amount;
// 					const idempotency_key == paymentId; // prevent duplicate charges
// 					const source = payment.token.id;
// 					const currency = 'usd';
// 					const charge = {amount, currency, source};

// 					return stripe.charges.create(charge, { idempotency_key });
// 				})
// 				.then(charge => {
// 					admin.database()
// 						.ref('payments/${userId}/${paymentId}/charge')
// 						.set(charge)
// 				})

// })

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest(async (request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});

// // functions.logger.info(`Message with ID: ${cardholder.id} added.`, {structuredData: true});
//   // response.send("Hello from Firebase locally!");
//   // response.send(cardholder.json());
//   response.send(card);
// });

// Listens for new messages added to /messages/:documentId/original and creates an
// uppercase version of the message to /messages/:documentId/uppercase
// exports.makeUppercase = functions.firestore.document('/messages/{documentId}')
//     .onCreate((snap, context) => {
//       // Grab the current value of what was written to Cloud Firestore.
//       const original = snap.data().original;

//       // Access the parameter `{documentId}` with `context.params`
//       functions.logger.log('Uppercasing', context.params.documentId, original);
      
//       const uppercase = original.toUpperCase();
      
//       // You must return a Promise when performing asynchronous tasks inside a Functions such as
//       // writing to Cloud Firestore.
//       // Setting an 'uppercase' field in Cloud Firestore document returns a Promise.
//       return snap.ref.set({uppercase}, {merge: true});
//     });


// --- Bevy Cloud Functions ---

exports.createBevyCard = functions.https.onRequest( async (req, res) => {
	const userid = req.query.userid;
	const username = req.query.username;
	const email = req.query.email;
	const phone_number = req.query.phone_number;
	const line1 = req.query.line1;
	// const line2 = req.query.line2;
	const city = req.query.city;
	const state = req.query.state;
	const postal_code = req.query.postal_code;

	try {
		//   name: 'Jenny Rosen',
		//   email: 'jenny.rosen@example.com',
		//   phone_number: '+18008675309',
		//   status: 'active',
		//   type: 'individual',
		//   billing: {
		//     address: {
		//       line1: '1234 Main Street', '12345 West 95th Street'
		//       city: 'San Francisco', 'Lenexa'
		//       state: 'CA', 'KS'
		//       postal_code: '94111', '66215'
		//       country: 'US',
		//     },
		//   },
		const cardholder = await stripe.issuing.cardholders.create({
			name: username,
			email: email,
			phone_number: phone_number,
			status: 'active',
			type: 'individual',
			billing: {
				address: {
					line1: line1,
					// line2: line2,
					city: city,
					state: state,
					postal_code: postal_code,
					country: 'US',
				},
			},
		});

		const card = await stripe.issuing.cards.create({
			cardholder: cardholder.id,
			type: 'virtual',
			currency: 'usd',
		});

		// const card = await stripe.issuing.cards.create({
		// 	cardholder: cardholder.id,
		// 	type: 'physical',
		// 	currency: 'usd',
		// 	shipping: {
		// 		address: {
		// 			city: city,
		// 			country: 'US',
		// 			line1: line1,
		// 			// line2: line2,
		// 			state: state,
		// 			postal_code: postal_code,
		// 		},
		// 		name: username, //username,
		// 		service: 'standard',
		// 	},
		// });

		await stripe.issuing.cards.update(
			card.id,
			{
				status: 'active',
				spending_controls: {
					spending_limits: [{
						amount: 1,
						interval: 'per_authorization',
					}],
				},
			}
		);

		// const cardexpand = await stripe.issuing.cards.retrieve(card.id, {
		// 	expand: ['number', 'cvc'],
		// });
		const userRef = db.collection('users').doc(userid);
		await userRef.update({
			cardID: card.id,
			cardNumber: card.last4,
		});

		res.send({
			statusCode: 200,
			body: {
				message: 'Created user card succesfully!',
				cardholder,
				card,
				cardID: card.id,
				cardNumber: card.last4,
			},
		});
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}

	// const writeResult = await admin.firestore().collection('messages').add({original: original});
	// res.json({result: `Message with ID: ${writeResult.id} added.`});
});

exports.chargeBevyBalance = functions.https.onRequest( async (req, res) => {
	const userid = req.query.userid;
	const amount = parseInt(req.query.amount);
	const token = req.query.token;
	const createdAt = parseFloat(req.query.createdAt);

	try {
		const charge = await stripe.charges.create({
			amount: amount,
			currency: 'usd',
			description: 'Charging Bevy Balance',
			source: token,
			expand: ['balance_transaction'],
		});

		// const transaction = await stripe.balanceTransactions.retrieve(
		// 	charge.balance_transaction
		// );

		await db.collection('paymentcharges').add({
			userID: userid,
			type: 'charge',
			chargeSID: charge.id,
			transactionSID: charge.balance_transaction.id,
			amount: charge.balance_transaction.amount,
			net: charge.balance_transaction.net,
			fee: charge.balance_transaction.fee,
			createdAt: createdAt,
			brand: charge.source.brand,
			last4: charge.source.last4,
			status: charge.balance_transaction.status,
			charge: charge,
		});

		const userRef = db.collection('users').doc(userid);
		const userDoc = await userRef.get();
		var availableAmount = userDoc.data().availableAmount + amount;

		await userRef.update({
			availableAmount: availableAmount,
		});

		if (availableAmount <= 0) {
			availableAmount = 1;
		}

		await stripe.issuing.cards.update(
			userDoc.data().cardID,
			{
				spending_controls: {
					spending_limits: [{
						amount: availableAmount,
						interval: 'per_authorization',
					}],
				},
			}
		);

		res.send({
			statusCode: 200,
			body: {
				message: 'Charged money succesfully!',
				userID: userid,
				type: 'charge',
				chargeSID: charge.id,
				transactionSID: charge.balance_transaction.id,
				amount: amount,
				net: charge.balance_transaction.net,
				fee: charge.balance_transaction.fee,
				charge: charge,
			},
		});
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

exports.createSaving = functions.https.onRequest( async (req, res) => {
	const userid = req.query.userid;
	const time = parseInt(req.query.time);
	const amount = parseInt(req.query.amount);
	const rounded = parseInt(req.query.rounded);
	const type = req.query.type;
	const createdAt = parseFloat(req.query.createdAt);

	try {
		await db.collection('paymentsavings').add({
			userID: userid,
			time: time,
			amount: amount,
			rounded: rounded,
			type: type,
			createdAt: createdAt,
		});

		const userRef = db.collection('users').doc(userid);
		const userDoc = await userRef.get();
		var availableAmount = userDoc.data().availableAmount - amount;
		var savedAmount = userDoc.data().savedAmount + amount;

		await userRef.update({
			availableAmount: availableAmount,
			savedAmount: savedAmount,
		});

		if (availableAmount <= 0) {
			availableAmount = 1;
		}

		await stripe.issuing.cards.update(
			userDoc.data().cardID,
			{
				spending_controls: {
					spending_limits: [{
						amount: availableAmount,
						interval: 'per_authorization',
					}],
				},
			}
		);

		res.send({
			statusCode: 200,
			body: {
				message: 'Created saving succesfully!',
				availableAmount: availableAmount,
				savedAmount: savedAmount,
			},
		});
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

exports.createCashout = functions.https.onRequest( async (req, res) => {
	const userid = req.query.userid;
	const amount = parseInt(req.query.amount);
	const type = req.query.type;
	const createdAt = parseFloat(req.query.createdAt);

	try {
		await db.collection('paymentcashouts').add({
			userID: userid,
			amount: amount,
			type: type,
			createdAt: createdAt,
		});

		const userRef = db.collection('users').doc(userid);
		const userDoc = await userRef.get();
		var availableAmount = userDoc.data().availableAmount + amount;
		var savedAmount = 0;

		await userRef.update({
			availableAmount: availableAmount,
			savedAmount: savedAmount,
		});

		if (availableAmount <= 0) {
			availableAmount = 1;
		}

		await stripe.issuing.cards.update(
			userDoc.data().cardID,
			{
				spending_controls: {
					spending_limits: [{
						amount: availableAmount,
						interval: 'per_authorization',
					}],
				},
			}
		);

		res.send({
			statusCode: 200,
			body: {
				message: 'Created cashout succesfully!',
				availableAmount: availableAmount,
				savedAmount: savedAmount,
			},
		});
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

exports.createSent = functions.https.onRequest( async (req, res) => {
	const senderID = req.query.senderID;
	const receiverID = req.query.receiverID;
	const amount = parseInt(req.query.amount);
	const type = req.query.type;
	const createdAt = parseFloat(req.query.createdAt);

	try {
		const senderRef = db.collection('users').doc(senderID);
		const senderDoc = await senderRef.get();
		var senderAvailableAmount = senderDoc.data().availableAmount - amount;

		const receiverRef = db.collection('users').doc(receiverID);
		const receiverDoc = await receiverRef.get();
		var receiverAvailableAmount = receiverDoc.data().availableAmount + amount;

		await db.collection('paymentsents').add({
			senderID: senderID,
			senderUsername: senderDoc.data().username,
			senderEmail: senderDoc.data().email,
			senderPhotoUrl: senderDoc.data().photoUrl ? senderDoc.data().photoUrl : "",
			receiverID: receiverID,
			receiverUsername: receiverDoc.data().username,
			receiverEmail: receiverDoc.data().email,
			receiverPhotoUrl: receiverDoc.data().photoUrl ? receiverDoc.data().photoUrl : "",
			amount: amount,
			type: type,
			createdAt: createdAt,
		});

		await senderRef.update({
			availableAmount: senderAvailableAmount,
		});

		if (senderAvailableAmount <= 0) {
			senderAvailableAmount = 1;
		}

		await stripe.issuing.cards.update(
			senderDoc.data().cardID,
			{
				spending_controls: {
					spending_limits: [{
						amount: senderAvailableAmount,
						interval: 'per_authorization',
					}],
				},
			}
		);

		await receiverRef.update({
			availableAmount: receiverAvailableAmount,
		});

		if (receiverAvailableAmount <= 0) {
			receiverAvailableAmount = 1;
		}

		await stripe.issuing.cards.update(
			receiverDoc.data().cardID,
			{
				spending_controls: {
					spending_limits: [{
						amount: receiverAvailableAmount,
						interval: 'per_authorization',
					}],
				},
			}
		);

		res.send({
			statusCode: 200,
			body: {
				message: 'Sending money succesfully!',
				availableAmount: senderAvailableAmount,
			},
		});
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

exports.getBevyBalance = functions.https.onRequest( async (req, res) => {
	const userid = req.query.userid;

	try {
		var payments = [];
		var charges = [];
		var sents = [];
		var receives = [];
		var savings = [];
		var requestfrommes = [];
		var requesttomes = [];
		var cashouts = [];
		var spends = [];
		var transactions = [];
		// var promises = [];
		var available = 0;
		// var pending = 0;
		var i = 0;
		var tmp;

		var snapshot = await db.collection('paymentcharges').where('userID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(charge => {
				tmp = charge.data();
				tmp.paymentID = charge.id;
				charges.push(tmp);
			});

			charges.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});

			// for (i = 0; i < charges.length; i ++) {
				// var charge = charges[i];
				// charge.type = "charge";
				// promises.push(stripe.balanceTransactions.retrieve(
				// 	charges[i].transactionSID
				// ));
			// }

			// var transactions = await Promise.all(promises);

			// for (i = 0; i < transactions.length; i ++) {
			// 	var transaction = transactions[i];
			// 	//if (transaction.status === 'available') {
			// 		//available += transaction.amount; //transaction.net
			// 	//} else {
			// 		//pending += transaction.amount; //transaction.net
			// 	//}
			// 	available += transaction.amount;
			// 	charges[i].status = transaction.status;
			// }
			payments = [...payments, ...charges];
		}

		snapshot = await db.collection('paymentsents').where('senderID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(sent => {
				tmp = sent.data();
				tmp.paymentID = sent.id;
				sents.push(tmp);
			});

			payments = [...payments, ...sents];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		snapshot = await db.collection('paymentsents').where('receiverID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(receive => {
				tmp = receive.data();
				tmp.paymentID = receive.id;
				receives.push(tmp);
			});

			for (i = 0; i < receives.length; i ++) {
				var receive = receives[i];
				if (receive.type === "sent") {
					receive.type = "receive";
				} else if (receive.type === "sentforrequest") {
					receive.type = "receiveforrequest";
				}
			}

			payments = [...payments, ...receives];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		snapshot = await db.collection('paymentsavings').where('userID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(saving => {
				tmp = saving.data();
				tmp.paymentID = saving.id;
				savings.push(tmp);
			});

			payments = [...payments, ...savings];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		snapshot = await db.collection('paymentrequests').where('senderID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(request => {
				tmp = request.data();
				tmp.paymentID = request.id;
				tmp.type = "requestfromme";
				requestfrommes.push(tmp);
			});

			payments = [...payments, ...requestfrommes];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		snapshot = await db.collection('paymentrequests').where('receiverID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(request => {
				tmp = request.data();
				tmp.paymentID = request.id;
				tmp.type = "requesttome";
				requesttomes.push(tmp);
			});

			payments = [...payments, ...requesttomes];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		snapshot = await db.collection('paymentcashouts').where('userID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(cashout => {
				tmp = cashout.data();
				tmp.paymentID = cashout.id;
				cashouts.push(tmp);
			});

			payments = [...payments, ...cashouts];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		snapshot = await db.collection('liveevents_spend').where('userID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(spend => {
				tmp = spend.data();
				tmp.paymentID = spend.id;
				spends.push(tmp);
			});

			payments = [...payments, ...spends];
			payments.sort((a, b) => {
				return b.createdAt - a.createdAt;
			});
		}

		// snapshot = await db.collection('liveevents_transaction').where('userID', '==', userid).get();

		// if (!snapshot.empty) {
		// 	snapshot.forEach(transaction => {
		// 		transactions.push(transaction.data());
		// 	});

		// 	payments = [...payments, ...transactions];
		// 	payments.sort((a, b) => {
		// 		return b.createdAt - a.createdAt;
		// 	});
		// }

		const userRef = db.collection('users').doc(userid)
		const userDoc = await userRef.get()

		res.send({
			statusCode: 200,
			body: {
				message: 'Getting transactions succesfully!',
				available: userDoc.data().availableAmount,
				payments: payments,
			},
		});
		return;
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

exports.getUserContacts = functions.https.onRequest( async (req, res) => {
	const userid = req.query.userid;

	try {
		var contactIDs = [];
		var users = [];
		var userDocs = [];
		var promises = [];
		var i = 0;

		var snapshot = await db.collection('contacts').where('ownerID', '==', userid).get();

		if (!snapshot.empty) {
			snapshot.forEach(contact => {
				contactIDs.push(contact.data().contactID);
			});

			for (i = 0; i < contactIDs.length; i ++) {
				promises.push(db.collection('users').doc(contactIDs[i]).get());
			}

			userDocs = await Promise.all(promises);

			for (i = 0; i < userDocs.length; i ++) {
				users = [...users, userDocs[i].data()];
			}

			users.sort((a, b) => {
				return b.username - a.username;
			});
		}

		res.send({
			statusCode: 200,
			body: {
				message: 'Getting contacts succesfully!',
				users: users,
			},
		});
		return;
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

exports.delUserContact = functions.https.onRequest( async (req, res) => {
	const ownerid = req.query.ownerid;
	const contactid = req.query.contactid;

	try {
		var contactIDs = [];
		var users = [];
		var userDocs = [];
		var promises = [];
		var i = 0;

		var snapshot = await db.collection('contacts').where('ownerID', '==', ownerid).get();

		if (!snapshot.empty) {
			snapshot.forEach(contact => {
				if (contact.data().contactID === contactid) {
					contact.ref.delete();
					res.send({
						statusCode: 200,
						body: {
							message: 'Deleting contact succesfully!',
						},
					});
					return;
				}
			});
		}
		return;
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}
});

//https://us-central1-bevy-b3121.cloudfunctions.net/events
//Signing secret : whsec_Xpv5qTkGziNM3LA8nSfCLFUcl9y4hqy3

// exports.events = functions.https.onRequest(async (req, res) => {
// 	// let sig = req.headers["stripe-signature"];
// 	// try {
// 	// } catch (err) {
// 	// 	return response.status(400).end(); // Signing signature failure, return an error 400
// 	// }
// 	// const reqobj = req.query.object;
// 	const firebaseCharge = await db.collection('endpoint').add({
// 		type: 'Test',
// 		// reqid: reqid,
// 		// reqobj: reqobj,
// 	});

// 	// res.send({
// 	// 	statusCode: 200,
// 	// 	body: {
// 	// 		reqid: reqid,
// 	// 		reqobj: reqobj,
// 	// 	},
// 	// });
// 	res.send('Test');
// });

/*
{
  "object": {
    "id": "iauth_1I1b81BcXqlUXR0jFWV0jcZM",
    "object": "issuing.authorization",
    "amount": 378,
    "amount_details": {
      "atm_fee": null
    },
    "approved": true,
    "authorization_method": "chip",
    "balance_transactions": [
      {
        "id": "txn_1I1b82BcXqlUXR0jO9welKqx",
        "object": "balance_transaction",
        "amount": -378,
        "available_on": 1608744482,
        "created": 1608744482,
        "currency": "usd",
        "description": "Hold for authorization",
        "exchange_rate": null,
        "fee": 0,
        "fee_details": [
        ],
        "net": -378,
        "reporting_category": "issuing_authorization_hold",
        "source": "iauth_1I1b81BcXqlUXR0jFWV0jcZM",
        "status": "available",
        "type": "issuing_authorization_hold"
      }
    ],
    "card": {
      "id": "ic_1GmVpOBcXqlUXR0jljtdga9g",
      "object": "issuing.card",
      "brand": "Visa",
      "cancellation_reason": null,
      "cardholder": {
        "id": "ich_1GmVogBcXqlUXR0j8OGAyxFq",
        "object": "issuing.cardholder",
        "billing": {
          "address": {
            "city": "Covington",
            "country": "US",
            "line1": "908 Madison Avenue",
            "line2": null,
            "postal_code": "41011",
            "state": "KY"
          }
        },
        "company": null,
        "created": 1590372806,
        "email": "nathan@michl.design",
        "individual": {
          "dob": null,
          "first_name": "Nathan",
          "last_name": "Ellis",
          "verification": {
            "document": {
              "back": null,
              "front": null
            }
          }
        },
        "livemode": true,
        "metadata": {
        },
        "name": "Nathan Ellis",
        "phone_number": "+19173401389",
        "requirements": {
          "disabled_reason": null,
          "past_due": [
          ]
        },
        "spending_controls": {
          "allowed_categories": [
          ],
          "blocked_categories": [
          ],
          "spending_limits": [
          ],
          "spending_limits_currency": null
        },
        "status": "active",
        "type": "individual"
      },
      "created": 1590372850,
      "currency": "usd",
      "exp_month": 4,
      "exp_year": 2023,
      "last4": "7407",
      "livemode": true,
      "metadata": {
      },
      "replaced_by": null,
      "replacement_for": null,
      "replacement_reason": null,
      "shipping": {
        "address": {
          "city": "Covington",
          "country": "US",
          "line1": "908 Madison Avenue",
          "line2": null,
          "postal_code": "41011",
          "state": "KY"
        },
        "carrier": "fedex",
        "eta": 1591017900,
        "name": "Nathan Ellis",
        "phone": null,
        "service": "priority",
        "status": "delivered",
        "tracking_number": "183563628485",
        "tracking_url": "https://www.fedex.com/apps/fedextrack/?action=track&tracknumbers=183563628485",
        "type": "individual"
      },
      "spending_controls": {
        "allowed_categories": null,
        "blocked_categories": null,
        "spending_limits": [
          {
            "amount": 50000,
            "categories": [
            ],
            "interval": "daily"
          }
        ],
        "spending_limits_currency": "usd"
      },
      "status": "active",
      "type": "physical"
    },
    "cardholder": "ich_1GmVogBcXqlUXR0j8OGAyxFq",
    "created": 1608744481,
    "currency": "usd",
    "livemode": true,
    "merchant_amount": 378,
    "merchant_currency": "usd",
    "merchant_data": {
      "category": "eating_places_restaurants",
      "city": "CINCINNATI",
      "country": "US",
      "name": "BIG-BOY-HMLTON-A",
      "network_id": "4445001543348",
      "postal_code": "45231",
      "state": "OH"
    },
    "metadata": {
    },
    "pending_request": null,
    "request_history": [
      {
        "amount": 378,
        "amount_details": {
          "atm_fee": null
        },
        "approved": true,
        "created": 1608744482,
        "currency": "usd",
        "merchant_amount": 378,
        "merchant_currency": "usd",
        "reason": "card_active"
      }
    ],
    "status": "pending",
    "transactions": [
    ],
    "verification_data": {
      "address_line1_check": "not_provided",
      "address_postal_code_check": "not_provided",
      "cvc_check": "not_provided",
      "expiry_check": "match"
    },
    "wallet": null
  }
}
*/

exports.liveEvents = functions.https.onRequest( async (request, response) => {
	let event;
	try {
		event = stripe.webhooks.constructEvent(request.rawBody, request.headers["stripe-signature"], 'whsec_5Af2EigHM1ZvamxrKP3wJoCQMvSCfon8'); // Validate the request

		// Handle the event
		// switch (event.type) {
		//   case 'charge.succeeded':
		//     const paymentIntent = event.data.object;
		//     console.log('PaymentIntent was successful!');
		//     break;
		//   case 'payment_method.attached':
		//     const paymentMethod = event.data.object;
		//     console.log('PaymentMethod was attached to a Customer!');
		//     break;
		//   // ... handle other event types
		//   default:
		//     console.log(`Unhandled event type ${event.type}`);
		// }

		// var eventType = 'none';
		// if (event.type === 'charge.succeeded') {
		// 	eventType = 'event type = charge.succeeded';
		// } else 

		if (event.type === 'issuing_authorization.created') {
			let approved = event.data.object.approved;
			let savingAmount = 100 - event.data.object.amount % 100;
			let roundedAmount = event.data.object.amount + savingAmount;
			let cardID = event.data.object.card.id;
			if (approved === true && cardID) {
				// let event.data.object.balance_transactions.0.id
				var snapshot = await db.collection('users').where('cardID', '==', cardID).get();

				if (!snapshot.empty) {
					var users = [];
					var i = 0;
					snapshot.forEach(user => {
						users.push(user);
					});

					if (users.length > 0) {
						// const userID = users[0].id;
						const userObj = users[0].data();
						const userRef = users[0].ref;

						var availableAmount = userObj.availableAmount - roundedAmount;
						var savedAmount = userObj.savedAmount + savingAmount;

						await userRef.update({
							availableAmount: availableAmount,
							savedAmount: savedAmount,
						});

						if (availableAmount <= 0) {
							availableAmount = 1;
						}

						await stripe.issuing.cards.update(
							cardID,
							{
								spending_controls: {
									spending_limits: [{
										amount: availableAmount,
										interval: 'per_authorization',
									}],
								},
							}
						);

						const spendRef = await db.collection('liveevents_spend').add({
							userID: userObj.userID,
							amount: roundedAmount,
							type: 'livespend',
							merchantName: event.data.object.merchant_data.name,
							cardID: cardID,
							approved: approved,
							createdAt: event.created,
							event,
						});

						await db.collection('paymentsavings').add({
							userID: userObj.userID,
							amount: savingAmount,
							rounded: roundedAmount,
							type: 'autosaving',
							time: 0,
							spendID: spendRef.id,
							merchantName: event.data.object.merchant_data.name,
							createdAt: event.created,
						});

						return response.json({ ref: 'Handled Event' });
					}
				}
			}
		} else if (event.type === 'issuing_transaction.created') {
			// let dispute = event.data.object.dispute;
			// amount = event.data.object.amount; // amount is minus or plus???
			// cardID = event.data.object.card;
			// if (dispute === null && amount && cardID) {
			// 	snapshot = await db.collection('users').where('cardID', '==', cardID).get();

			// 	if (!snapshot.empty) {
			// 		users = [];
			// 		i = 0;
			// 		snapshot.forEach(user => {
			// 			users.push(user);
			// 		});

			// 		if (users.length > 0) {
			// 			// const userID = users[0].id;
			// 			userObj = users[0].data();
			// 			userRef = users[0].ref;

			// 			availableAmount = userObj.availableAmount + amount;

			// 			await userRef.update({
			// 				availableAmount: availableAmount,
			// 			});

			// 			if (availableAmount <= 0) {
			// 				availableAmount = 1;
			// 			}

			// 			await stripe.issuing.cards.update(
			// 				cardID,
			// 				{
			// 					spending_controls: {
			// 						spending_limits: [{
			// 							amount: availableAmount,
			// 							interval: 'per_authorization',
			// 						}],
			// 					},
			// 				}
			// 			);

			// 			await db.collection('liveevents_transaction').add({
			// 				userID: userObj.userID,
			// 				amount: amount,
			// 				type: 'livetransaction',
			// 				merchantName: event.data.object.merchant_data.name,
			// 				cardID: cardID,
			// 				createdAt: event.created,
			// 				event,
			// 			});

			// 			return response.json({ ref: 'Handled Live Event' });
			// 		}
			// 	}
			// }
		}

		await db.collection('liveevents_unhandled').add({
							event,
							type: 'Unhandled Live Event',
						});
		return response.json({ ref: 'Unhandled Live Event' });

	} catch (err) {
		console.error(err)
		await db.collection('liveevents_failed').add({
					event,
					reason: err,
					type: 'Live Error Catched',
				});
		// return response.status(400).end(); // Signing signature failure, return an error 400
		return response.json({ ref: 'Live Error catched' });
	}
});

exports.testEvents = functions.https.onRequest( async (request, response) => {
	let event;
	try {
		event = stripe.webhooks.constructEvent(request.rawBody, request.headers["stripe-signature"], 'whsec_Xpv5qTkGziNM3LA8nSfCLFUcl9y4hqy3');

		await db.collection('testevents_unhandled').add(event);
		return response.json({ ref: 'Unhandled Test Event' });

	} catch (err) {

		await db.collection('testevents_failed').add({
			event,
			reason: err,
			type: 'Test Error Catched',
		});
		return response.json({ ref: 'Test Error Catched' });
	}
});

exports.tempFunc = functions.https.onRequest( async (req, res) => {
	const username = req.query.username;
	const email = req.query.email;
	const phone_number = req.query.phone_number;
	const line1 = req.query.line1;
	const city = req.query.city;
	const state = req.query.state;
	const postal_code = req.query.postal_code;

	try {
		const cardholder = await stripe.issuing.cardholders.create({
			name: username,
			email: email,
			phone_number: phone_number,
			status: 'active',
			type: 'individual',
			billing: {
				address: {
					line1: line1,
					city: city,
					state: state,
					postal_code: postal_code,
					country: 'US',
				},
			},
		});

		const card = await stripe.issuing.cards.create({
			cardholder: cardholder.id,
			type: 'physical',
			currency: 'usd',
			shipping: {
				address: {
					city: city,
					country: 'US',
					line1: line1,
					state: state,
					postal_code: postal_code,
				},
				name: 'Bevy', //username,
				service: 'standard',
			},
		});

		const cardobj = await stripe.issuing.cards.update(
			card.id,
			{
				status: 'active',
				spending_controls: {
					spending_limits: [{
						amount: 1,
						interval: 'per_authorization',
					}],
				},
			}
		);

		const cardNum = await stripe.issuing.cards.retrieve(card.id, {
			expand: ['number', 'cvc'],
		});

		res.send({
			statusCode: 200,
			body: {
				message: 'Created user card succesfully!',
				cardholder,
				card,
				cardID: card.id,
				cardNumber: card.last4,
				cardNum: cardNum.number,
			},
		});
	} catch (err) {
		res.send({
			statusCode: 500,
			body: {
				message: err.message,
				err
			},
		});
	}

	// const writeResult = await admin.firestore().collection('messages').add({original: original});
	// res.json({result: `Message with ID: ${writeResult.id} added.`});
});


