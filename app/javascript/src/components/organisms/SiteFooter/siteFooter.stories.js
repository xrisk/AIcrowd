import React from 'react';

import SiteFooter from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/SiteFooter',
  component: SiteFooter,
  argTypes: {
    SiteFooter: {
      control: {
        options: [],
      },
    },
  },
};

const Template = args => {
  return <SiteFooter {...args} />;
};

export const siteFooter = Template.bind({});
siteFooter.args = {
  // topParticipants: data,
};
