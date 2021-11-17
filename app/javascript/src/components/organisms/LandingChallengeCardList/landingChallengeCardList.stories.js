import React from 'react';

import landingChallengeCard from '../LandingChallengeCard/landingChallengeCard.stories';
import LandingChallengeCardList from './index';

const card02 = `assets/home/card/neu ui cards-02.png`;
const card04 = `assets/home/card/neu ui cards-04.png`;
const card06 = `assets/home/card/neu ui cards-06.png`;
const card08 = `assets/home/card/neu ui cards-08.png`;
const card10 = `assets/home/card/neu ui cards-10.png`;
const card12 = `assets/home/card/neu ui cards-12.png`;
const card14 = `assets/home/card/neu ui cards-14.png`;

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingChallengeCardList',
  component: LandingChallengeCardList,
  args: {
    challengeListData: [
      {
        ...landingChallengeCard.args,
      },
      {
        ...landingChallengeCard.args,
        image: card02,
        name: 'MineRL Diamond',
        color: '#FFFFFF',
        organizers: [
          {
            name: 'ADDI',
            logo: '/assets/images/addi-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'Music Demixing',
        color: '#003366',
        image: card06,
        organizers: [
          {
            name: 'ADDI',
            logo: '/assets/images/addi-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'Airborne',
        color: '#213041',
        image: card08,
        organizers: [
          {
            name: 'ADDI',
            logo: '/assets/images/addi-logo.png',
          },
          {
            name: 'OpenAI',
            logo: '/assets/images/openai-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'ADDI',
        color: '#4C117F',
        image: card04,
        cardBadge: false,
        organizers: [
          {
            name: 'Seerave',
            logo: '/assets/images/seerave-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'Neural MMO',
        color: '#FFFFFF',
        image: card10,
        organizers: [
          {
            name: 'C.H.A.I. (UC Berkely)',
            logo: '/assets/images/chai-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'Neural MMO',
        color: '#8E4165',
        image: card12,
        cardBadge: false,
        organizers: [
          {
            name: 'ADDI',
            logo: '/assets/images/addi-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'Neural MMO',
        color: '#FFFFFF',
        image: card14,
        organizers: [
          {
            name: 'ADDI',
            logo: '/assets/images/addi-logo.png',
          },
        ],
      },
      {
        ...landingChallengeCard.args,
        name: 'Neural MMO',
        color: '#FFFFFF',
        image: card10,
        organizers: [
          {
            name: 'ADDI',
            logo: '/assets/images/addi-logo.png',
          },
        ],
      },
    ],
  },
  argTypes: {},
};

const Template = args => <LandingChallengeCardList {...args} />;

export const landingChallengeCardList = Template.bind({});
landingChallengeCardList.args = {};
