import React from 'react';

import PartnerBarLanding from './index';

const unity = '/assets/images/partner-logo-unity.svg';
const sbb = '/assets/images/partner-logo-sbb.svg';
const uber = '/assets/images/partner-logo-uber.svg';
const openai = '/assets/images/partner-logo-openai.svg';
const stanford = '/assets/images/partner-logo-stanford.png';
const firmenich = '/assets/images/partner-logo-firmenich.svg';
const spotify = '/assets/images/partner-logo-spotify.svg';
const aws = '/assets/images/partner-logo-aws.svg';

// This default export determines where your story goes in the story list
export default {
  title: 'Organisms/PartnerBarLanding',
  component: PartnerBarLanding,
  args: {
    logos: [unity, sbb, uber, openai, stanford, firmenich, spotify, aws],
    color: 'default',
  },
  argTypes: {
    color: {
      control: {
        type: 'radio',
        options: ['default', 'dark'],
      },
    },
  },
};

const Template = args => <PartnerBarLanding {...args} />;

export const partnerBarLanding = Template.bind({});
partnerBarLanding.args = {};
