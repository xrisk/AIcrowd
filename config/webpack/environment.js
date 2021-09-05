const { environment } = require('@rails/webpacker')
const sharedConfig = require('./shared.js')

module.exports = merge(environment, customConfig)
