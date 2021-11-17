import React from 'react';

import CircleValue from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/CircleValue',
  component: CircleValue,
  args: {
    value: 25,
    size: 'default',
    onCard: false,
  },
  argTypes: {
    size: {
      type: 'radio',
      options: ['md', 'default'],
    },
  },
};

export const ValueCircle = args => <CircleValue {...args} />;
