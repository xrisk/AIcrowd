import React from 'react';

import LandingCarousel from './index';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/LandingCarousel',
  component: LandingCarousel,
  args: {
    leaderDescription:
      '1-2 Sentences related to how these winners were selected or what does leaderboard winners mean.',
    quote: 'I love you the more in that I believe you had liked me for my own sake and for nothing else',
    author: 'John Keats',
    borderColor: 'red',
    image: '/assets/images/custom-avatar-1.png',
    quotes: [
      {
        quote:
          'Crowdsourcing far exceeded our expectations - you not only get $new solutions$, but also a $deeper insight to the problem$ you are trying to $solve$.',
        author: 'John Keats',
        post: 'Postdoctoral Researcher, Stanford',
      },
      {
        quote: "I have not failed. I've just found 10,000 ways that won't work.",
        author: 'Thomas A. Edison',
        post: 'Postdoctoral Researcher, Stanford',
      },
      {
        quote: 'But man is not made for defeat. A man can be destroyed but not defeated.',
        author: 'Ernest Hemingway',
        post: 'Postdoctoral Researcher, Stanford',
      },
      {
        quote:
          'The world as we have created it is a process of our thinking. It cannot be changed without changing our thinking.',
        author: 'Albert Einstein',
        post: 'Postdoctoral Researcher, Stanford',
      },
      {
        quote: 'The person, be it gentleman or lady, who has not pleasure in a good novel, must be intolerably stupid.',
        author: 'Jane Austen',
        post: 'Postdoctoral Researcher, Stanford',
      },
    ],
  },
  argTypes: {
    WinnerCommunity: {
      control: {
        options: [],
      },
    },
  },
};

const Template = args => <LandingCarousel {...args} />;

export const landingCarousel = Template.bind({});
landingCarousel.args = {};
