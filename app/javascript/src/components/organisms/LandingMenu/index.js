import React from 'react';
import Link from 'next/link';

import styles from './landingMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
const { main, menuWrapper, loginText, socialIconWrapper } = styles;

const LandingMenu = () => (
  <>
    <div className={main}>
      <div className={menuWrapper}>
        <Link href="/host-a-Challenge">
          <a>Host a Challenge</a>
        </Link>
        <Link href="/challenges">
          <a>Challenges</a>
        </Link>
        <Link href="/community">
          <a>Community</a>
        </Link>
        <Link href="/team">
          <a>Our Team</a>
        </Link>
        <Link href="/jobs">
          <a>Jobs</a>
        </Link>
        <div className={loginText}>
          <Link href="/login">
            <a>Log In</a>
          </Link>
        </div>
        <Link href="/signup">
          <a>Signup</a>
        </Link>
        <div className={socialIconWrapper}>
          <SocialButtons socialType="facebook" iconType="outline" link="https://www.facebook.com/AIcrowdHQ/" />
          <SocialButtons socialType="twitter" iconType="outline" link="https://twitter.com/AIcrowdHQ" />
          <SocialButtons socialType="linkedin" iconType="outline" link="https://www.linkedin.com/company/aicrowd" />
          <SocialButtons
            socialType="youtube"
            iconType="outline"
            link="https://www.youtube.com/channel/UCUWbe23kxbwpaAP9AlzZQbQ"
          />
          <SocialButtons socialType="discord" iconType="outline" link="/" />
        </div>
      </div>
    </div>
  </>
);

export default LandingMenu;
