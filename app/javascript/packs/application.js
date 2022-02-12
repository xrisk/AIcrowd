/* eslint no-console:0 */

require('chartkick');
require("chart.js");

import 'regenerator-runtime/runtime'

import '../stimulus_js/index.js';
// Support component names relative to this directory:
var componentRequireContext = require.context("src/components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);
