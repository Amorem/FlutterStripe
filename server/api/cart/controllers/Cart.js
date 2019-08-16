"use strict";

/**
 * Cart.js controller
 *
 * @description: A set of functions called "actions" for managing `Cart`.
 */

module.exports = {
  /**
   * Retrieve cart records.
   *
   * @return {Object|Array}
   */

  find: async (ctx, next, { populate } = {}) => {
    if (ctx.query._q) {
      return strapi.services.cart.search(ctx.query);
    } else {
      return strapi.services.cart.fetchAll(ctx.query, populate);
    }
  },

  /**
   * Retrieve a cart record.
   *
   * @return {Object}
   */

  findOne: async ctx => {
    if (!ctx.params._id.match(/^[0-9a-fA-F]{24}$/)) {
      return ctx.notFound();
    }

    return strapi.services.cart.fetch(ctx.params);
  },

  /**
   * Count cart records.
   *
   * @return {Number}
   */

  count: async ctx => {
    return strapi.services.cart.count(ctx.query);
  },

  /**
   * Create a/an cart record.
   *
   * @return {Object}
   */

  create: async ctx => {
    return strapi.services.cart.add(ctx.request.body);
  },

  /**
   * Update a/an cart record.
   *
   * @return {Object}
   */

  update: async (ctx, next) => {
    const { products } = ctx.request.body;
    return strapi.services.cart.edit(ctx.params, {
      products: JSON.parse(products)
    });
  },

  /**
   * Destroy a/an cart record.
   *
   * @return {Object}
   */

  destroy: async (ctx, next) => {
    return strapi.services.cart.remove(ctx.params);
  }
};
