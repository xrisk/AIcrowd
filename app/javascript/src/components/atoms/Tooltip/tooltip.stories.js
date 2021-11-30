/* eslint-disable import/no-anonymous-default-export */
import React from 'react';

import Tooltip from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/Tooltip',
  component: Tooltip,
};

export const tooltip = () => (
  <Tooltip position="up" label="Whats up!">
    Tooltip Example
  </Tooltip>
);

tooltip.decorators = [
  Story => (
    <div style={{ margin: '3em' }}>
      <Story />
    </div>
  ),
];
