import React from 'react';

import landingDropdownMenuStories from 'src/components/molecules/LandingDropdownMenu/landingDropdownMenu.stories';
import LandingNavBar from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingNavBar',
  component: LandingNavBar,
  args: {
    moreMenuItem: landingDropdownMenuStories.args.menu,
    communityMenuItem: [
      {
        name: 'Blog',
        link: '/blog',
      },
      {
        name: 'Forum',
        link: '/forum',
      },
      {
        name: 'Showcase',
        link: '/showcase',
      },
    ],
    challengesMenuItem: [
      {
        name: 'Ongoing Challenges',
        link: '/ongoing-challenges',
      },
      {
        name: 'Practice Problems',
        link: '/practice-problems',
      },
    ],
  },
  argTypes: {
    LandingNavBar: {
      control: {
        options: [],
      },
    },
  },
};

const Template = args => <LandingNavBar {...args} />;

export const landingNavBar = Template.bind({});
landingNavBar.args = {};
