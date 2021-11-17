import React from 'react';

import CardBadge from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Atoms/CardBadge',
  component: CardBadge,
  args: {
    cardBadge: true,
    badgeColor: '#44B174',
    challengeEndDate: '2021/10/30',
  },
};

const Template = args => <CardBadge {...args} />;

export const cardBadge = Template.bind({});

cardBadge.args = {};
