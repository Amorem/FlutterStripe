'use strict';

const stripe = require('stripe')('sk_test_DiKwkQDvx2eURpCX0thg5TDc');

/**
 * A set of functions called "actions" for `Card`
 */

module.exports = {
  index: async ctx => {
    const customerId = ctx.request.querystring;
    const customerData = await stripe.customers.retrieve(customerId);
    const cardData = customerData.sources.data;
    ctx.send(cardData);
  }
};
