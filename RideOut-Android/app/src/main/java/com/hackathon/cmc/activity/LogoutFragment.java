package com.hackathon.cmc.activity;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hackathon.cmc.R;

public class LogoutFragment extends Fragment {
	
	public LogoutFragment(){}
	
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
 
        View rootView = inflater.inflate(R.layout.fragment_logout, container, false);
         
        return rootView;
    }
}
