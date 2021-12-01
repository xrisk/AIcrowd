import React from 'react';
import Link from 'next/link';

import styles from './landingMenu.module.scss';
import SocialButtons from 'src/components/atoms/Button/SocialButtons';
const { main, menuWrapper, loginText, socialIconWrapper } = styles;

const LandingMenu = ({ profileMenuItem, isLoggedIn }) => (
  <>
    <div className={main}>
      <div className={menuWrapper}>
        <Link href="/landing_page/host">
          <a>Host a Challenge</a>
        </Link>
        <Link href="/challenges">
          <a>Challenges</a>
        </Link>
        <Link href="https://discourse.aicrowd.com">
          <a>Community</a>
        </Link>
        <Link href="/research">
          <a>Research</a>
        </Link>
        <Link href="https://blog.aicrowd.com/">
          <a>Blog</a>
        </Link>
        {!isLoggedIn && (
          <>
            <div className={loginText}>
              <a href="/participants/sign_in">
                Log In
              </a>
            </div>
            <a href="/participants/sign_up">
              Signup
            </a>
          </>
        )}

        {isLoggedIn &&
          profileMenuItem.map(item => {
            const { name, link } = item;
            return (
              <div className={name === 'Profile' ? loginText : ''} key={name}>
                <a href={link}>
                  {name}
                </a>
              </div>
            );
          })}

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
