import React from 'react';

import avatarGroupStories from 'src/components/molecules/AvatarGroup/avatarGroup.stories';
import cardBadgeStories from 'src/components/atoms/CardBadge/cardBadge.stories';
import LandingChallengeCard from './index';

const challengeImage = 'assets/home/card/neu ui cards-14.png';
const organizerImage = 'assets/home/card/sony.png';

// This default export determines where your story goes in the story list
export default {
  title: 'Old/LandingChallengeCard',
  component: LandingChallengeCard,
  args: {
    image: challengeImage,
    name: 'Music Demixing Challenge @ISMIR2021 challenge',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Massa morbi',
    participant: 'Participants',
    submissionCount: '543',
    organizerImage: organizerImage,
    prizes: ['$50,000', 'Authorship', 'Misc Prizes'],
    hashtags: ['reinforcement-learning', 'music-challenge'],
    ...avatarGroupStories.args,
    color: '#19426E',
    ...cardBadgeStories.args,
  },
  argTypes: {},
};

const Template = args => <LandingChallengeCard {...args} />;

export const landingChallengeCard = Template.bind({});
landingChallengeCard.args = {};
