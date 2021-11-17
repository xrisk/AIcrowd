import React from 'react';

import ActionButton from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/Form Elements/Buttons/ActionButtons',
  component: ActionButton,
  args: {
    type: 'add',
  },
  argTypes: {
    type: {
      control: {
        type: 'radio',
        options: ['add', 'rerun', 'github', 'google'],
      },
    },
  },
};

export const actionButton = args => <ActionButton {...args} />;
