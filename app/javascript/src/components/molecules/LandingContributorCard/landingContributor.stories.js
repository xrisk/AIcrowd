import React from 'react';

import LandingContributorCard from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/LandingContributorCard',
  component: LandingContributorCard,
  args: {
    username: 'A_user_name',
    count: '5,054',
    image: '/assets/images/custom-avatar-3.png',
    onCard: false,
  },
};

const Template = args => <LandingContributorCard {...args} />;

export const landingContributorCard = Template.bind({});
landingContributorCard.args = {};
