import React from 'react';

import landingChallengeCardStories from '../LandingChallengeCard/landingChallengeCard.stories';
import landingStatListStories from '../LandingStatList/landingStatList.stories';
import MastHeadLanding from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/MastHeadLanding',
  component: MastHeadLanding,
  args: {
    ...landingStatListStories.args,
    ...landingChallengeCardStories.args,
  },
};

const Template = args => <MastHeadLanding {...args} />;

export const mastHeadLanding = Template.bind({});
mastHeadLanding.args = {};
