import React from 'react';

import SocialButtons from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/Form Elements/Buttons/SocialButtons',
  component: SocialButtons,
  argTypes: {
    socialType: {
      control: {
        type: 'radio',
        options: ['facebook', 'linkedin', 'twitter', 'discord', 'youtube'],
      },
    },
    iconType: {
      control: {
        type: 'radio',
        options: ['outline', 'default'],
      },
    },
  },
  args: {
    socialType: 'twitter',
    link: '',
    iconType: 'default',
  },
  decorators: [
    Story => (
      <div style={{ margin: '2.5em' }}>
        <Story />
      </div>
    ),
  ],
};

const Template = args => <SocialButtons {...args} />;

export const socialButtons = Template.bind({});
socialButtons.args = {};
