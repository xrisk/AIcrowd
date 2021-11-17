import React from 'react';

import LandingNotebookCard from './index';

const notebookImage = `/assets/images/notebook.png`;

// This default export determines where your story goes in the story list
export default {
  title: 'Molecules/LandingNotebookCard',
  component: LandingNotebookCard,
  args: {
    title: 'Welcome to NetHack and the NetHack Learning Environment!',
    description: 'Welcome to NetHack and the NetHack Learning Environment!',
    lastUpdated: '6 hours ago',
    image: notebookImage,
    author: 'John Doe',
  },
};

const Template = args => <LandingNotebookCard {...args} />;

export const landingNotebookCard = Template.bind({});
landingNotebookCard.args = {};
