package com.junsu.webservice.junsuspringboot2webservicedemo.config.auth;

import com.junsu.webservice.junsuspringboot2webservicedemo.config.auth.dto.OAuthAttributes;
import com.junsu.webservice.junsuspringboot2webservicedemo.config.auth.dto.SessionUser;
import com.junsu.webservice.junsuspringboot2webservicedemo.domain.user.User;
import com.junsu.webservice.junsuspringboot2webservicedemo.domain.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.Collections;

@RequiredArgsConstructor
@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {
    private final UserRepository userRepository;
    private final HttpSession httpSession;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2UserService delegate = new DefaultOAuth2UserService();
        OAuth2User oAuth2User = delegate.loadUser(userRequest);

        // 현재 로그인 진행 중인 서비스를 구분하는 코드
        // 네이버/구글 등 어떤 소셜로그인인지 구분하기위해 사용
        String registrationId = userRequest.getClientRegistration().getRegistrationId();

        // OAuth2 로그인 진행 시 키가 되는 필드값 (Primary Key)
        // Google: "sub", Naver, Kakao Not Support
        // Naver/Google Login을 동시 지원할 떄 사용.
        String userNameAttributeName = userRequest.getClientRegistration().getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        // OAuth2UserService를 통해 가져온 OAuth2User의 attribute를 담은 클래스
        OAuthAttributes attributes = OAuthAttributes.of(registrationId, userNameAttributeName, oAuth2User.getAttributes());

        User user = saveOrUpdate(attributes);

        // Why Not User Entity, SessionUser dto?
        // Not Serialize Error
        // entity 역할에 충실하도록 하고, Session용 Dto 생성하여 관리(유지보수에 용이)
        httpSession.setAttribute("user", new SessionUser(user));

        return new DefaultOAuth2User(Collections.singleton(new SimpleGrantedAuthority(user.getRoleKey())), attributes.getAttributes(), attributes.getNameAttributeKey());
    }

    private User saveOrUpdate(OAuthAttributes attributes) {
        User user = userRepository.findByEmail(attributes.getEmail())
                .map(entity -> entity.update(attributes.getName(), attributes.getPicture()))
                .orElse(attributes.toEntity());

        return userRepository.save(user);
    }
}
