import React from 'react';
import cardBadgeStories from 'src/components/atoms/CardBadge/cardBadge.stories';

import avatarGroupStories from 'src/components/molecules/AvatarGroup/avatarGroup.stories';
import LandingChallengeCard from './index';

const challengeImage = '/assets/images/challenge-banner-image-example.png';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingChallengeCard',
  component: LandingChallengeCard,
  args: {
    image: challengeImage,
    name: 'Flatland AMLD 2021 Competition',
    prize: 'Winner to speak at AMLD 2021',
    ...avatarGroupStories.args,
    color: '#0F2F90',
    ...cardBadgeStories.args,
    organizers: [
      {
        name: 'ADDI',
        logo: '/assets/images/addi-logo.png',
        link: '',
      },
    ],
  },
  argTypes: {},
};

const Template = args => <LandingChallengeCard {...args} />;

export const landingChallengeCard = Template.bind({});
landingChallengeCard.args = {};
