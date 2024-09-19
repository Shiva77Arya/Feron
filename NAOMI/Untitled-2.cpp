#include<std
int firstUniqueChar(string s) {
    len = s.length()
    for(i = 0 to i < len){
        bool found = true
        for(j = i+1 to j < len){
            if(s[i] == s[j]){
                found = false
                break
            }
        }
        if(found == true){
            return i
        }
    }
    return -1
}
int main()
{
   string str = 'statistics';
   cout<<firstUniqueChar(str);
   return 0;
}