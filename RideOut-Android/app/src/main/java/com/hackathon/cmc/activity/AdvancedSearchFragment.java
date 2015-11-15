package com.hackathon.cmc.activity;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hackathon.cmc.R;

public class AdvancedSearchFragment extends Fragment {
	
	public AdvancedSearchFragment(){}
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
 
        View rootView = inflater.inflate(R.layout.fragment_advanced_search, container, false);
         
        return rootView;
    }
}
