import React from 'react';

import AicrowdLogo from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/AIcrowdLogo',
  component: AicrowdLogo,
  args: {
    type: 'full',
  },
  argTypes: {
    type: {
      control: {
        type: 'radio',
        options: ['full', 'mark', 'text'],
      },
    },
  },
};

export const aicrowdLogo = args => <AicrowdLogo {...args} />;
