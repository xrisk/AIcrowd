import React from 'react';

import LandingSubmissionCard from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/LandingSubmissionCard',
  component: LandingSubmissionCard,
  args: {
    title: 'About Submission',
    description: 'Hockey Puck Tracking Challenge',
    comment_count: 2,
    isComment: true,
    image: '/assets/images/custom-avatar-3.png',
    onCard: true,
    borderColor: '#fff',
    tier: 2,
  },
};

const Template = args => <LandingSubmissionCard {...args} />;

export const landingSubmissionCard = Template.bind({});
landingSubmissionCard.args = {};
