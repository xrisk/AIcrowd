import React from 'react';
import LandingCommunityMap from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingCommunityMap',
  component: LandingCommunityMap,
  args: {
    communityMap: `/assets/home/map.svg`,
    communityMapAvatar: `/assets/home/map-avatar.png`,
  },
  argTypes: {},
};

const Template = args => <LandingCommunityMap {...args} />;

export const landingCommunityMap = Template.bind({});
landingCommunityMap.args = {};
