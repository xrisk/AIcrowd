import React from 'react';

import LandingMenu from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingMenu',
  component: LandingMenu,
  args: {},
  argTypes: {
    LandingMenu: {
      control: {
        options: [],
      },
    },
  },
};

const Template = args => <LandingMenu {...args} />;

export const landingMenu = Template.bind({});
landingMenu.args = {};
