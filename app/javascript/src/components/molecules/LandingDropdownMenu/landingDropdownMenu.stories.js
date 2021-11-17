import React from 'react';

import LandingDropdownMenu from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/LandingDropdownMenu',
  component: LandingDropdownMenu,
  args: {
    menu: [
      {
        name: 'Organize a challenge',
        link: '/organize',
      },
      {
        name: 'Our Team',
        link: '/team',
      },
      {
        name: 'Jobs',
        link: '/organize',
      },
    ],
    showSocial: true,
  },
};

const Template = args => <LandingDropdownMenu {...args} />;

export const landingDropdownMenu = Template.bind({});
landingDropdownMenu.args = {};
