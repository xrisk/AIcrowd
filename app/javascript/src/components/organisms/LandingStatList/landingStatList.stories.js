import React from 'react';
import landingStatItemStories from 'src/components/molecules/LandingStatItem/landingStatItem.stories';

import LandingStatList from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingStatList',
  component: LandingStatList,
  args: {
    statListData: [
      {
        ...landingStatItemStories.args,
      },
      {
        ...landingStatItemStories.args,
        count: '25k',
        statText: 'Community Members',
      },
      {
        ...landingStatItemStories.args,
        count: '$250k',
        statText: 'Awarded in Prizes',
      },
      // {
      //   ...landingStatItemStories.args,
      //   statText: 'Submissions',
      // },
      {
        ...landingStatItemStories.args,
        count: '60',
        statText: 'Research Papers',
      },
      {
        ...landingStatItemStories.args,
        count: '12 TB',
        statText: 'Codes, Models & Datasets',
      },
    ],
  },
  argTypes: {},
};

const Template = args => <LandingStatList {...args} />;

export const landingStatList = Template.bind({});
landingStatList.args = {};
