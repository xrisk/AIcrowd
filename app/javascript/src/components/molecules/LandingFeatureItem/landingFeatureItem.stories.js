import React from 'react';

import LandingFeatureItem from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/LandingFeatureItem',
  component: LandingFeatureItem,
  args: {
    title: 'Out-of-the-Box Challenges',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
  },
};

const Template = args => <LandingFeatureItem {...args} />;

export const landingFeatureItem = Template.bind({});
landingFeatureItem.args = {};
