import React from 'react';

import LandingStatItem from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/LandingStatItem',
  component: LandingStatItem,
  args: {
    count: 80,
    statText: 'Completed Challenges',
  },
};

const Template = args => <LandingStatItem {...args} />;

export const landingStatItem = Template.bind({});
landingStatItem.args = {};
