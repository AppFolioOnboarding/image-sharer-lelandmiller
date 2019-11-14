import React from 'react';
import { shallow } from 'enzyme';
import { expect } from 'chai';
import { describe, it } from 'mocha';

import Footer from '../../components/Footer';

describe('<Footer />', () => {
  it('should display correct text', () => {
    const wrapper = shallow(<Footer />);
    expect(wrapper.text()).equals('Copyright: Appfolio Inc. Onboarding');
  });
});
