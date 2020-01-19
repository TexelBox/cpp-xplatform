#ifndef PREFIX_UTILS_STRING_UTILS_HPP_
#define PREFIX_UTILS_STRING_UTILS_HPP_

#include <algorithm>
#include <cctype>
#include <locale>

namespace prefix::utils {
    // reference: https://stackoverflow.com/questions/216823/whats-the-best-way-to-trim-stdstring

    // trim front (in-place)
    inline void ltrim(std::string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](int ch) {
            return !std::isspace(ch);
        }));
    }

    // trim end (in-place)
    inline void rtrim(std::string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), [](int ch) {
            return !std::isspace(ch);
        }).base(), s.end());
    }

    // trim both sides (in-place)
    inline void trim(std::string &s) {
        ltrim(s);
        rtrim(s);
    }

    // trim front (copy)
    inline std::string ltrim_copy(std::string s) {
        ltrim(s);
        return s;
    }

    // trim end (copy)
    inline std::string rtrim_copy(std::string s) {
        rtrim(s);
        return s;
    }

    // trim both sides (copy)
    inline std::string trim_copy(std::string s) {
        trim(s);
        return s;
    }
}

#endif // PREFIX_UTILS_STRING_UTILS_HPP_
