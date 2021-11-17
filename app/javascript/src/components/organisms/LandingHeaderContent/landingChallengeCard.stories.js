import React from 'react';

import LandingHeaderContent from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingHeaderContent',
  component: LandingHeaderContent,
  args: {
    title: 'Discussions & Community',
    description:
      'We are a vibrant, growing community. On our forums, you can discuss the latest trends in AI research, enjoy peer support, and hangout with wacky cool innovators. You might even find co-founders for your AI startup or co-authors for your next ground-breaking research paper.',
    buttonText: 'Our discord community',
    hero: false,
  },
  argTypes: {},
};

const Template = args => <LandingHeaderContent {...args} />;

export const landingHeaderContent = Template.bind({});
landingHeaderContent.args = {};
